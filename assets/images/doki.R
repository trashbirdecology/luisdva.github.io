### httr directly
library(httr)
library(dplyr)
library(magrittr)
library(rvest)
library(curlconverter) # from github ("hrbrmstr/curlconverter")
library(tibble)

# pasted from browser developer tools Network tab after making the request
dogcurl <- "curl 'https://dockdogs.com/wp-admin/admin-ajax.php' -H 'origin: https://dockdogs.com' -H 'accept-encoding: gzip, deflate, br' -H 'x-requested-with: XMLHttpRequest' -H 'accept-language: en-US,en;q=0.8,es;q=0.6,de;q=0.4' -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'accept: */*' -H 'referer: https://dockdogs.com/rankings-results/rankings/' -H 'authority: dockdogs.com' -H 'cookie: PHPSESSID=ef7be54d8686a64b24977d207df14a1f; _ga=GA1.2.1978268822.1499538893; _gid=GA1.2.1207182401.1499538893; _gat=1' --data 'action=my_test_ajax_call&ranking_type=1&event_type=N&discipline=1&filename=rank&disciplinetxt=&event_typetxt=&seasontxt=&designationtxt=&season=26' --compressed"
# straighten pasted cURL
stdogcurl <- straighten(dogcurl)
# make into POST request
stdogreq <- make_req(stdogcurl)
# run the request, parse the content
res <- content(stdogreq[[1]](),as="parsed")

# extract the html tables (first two are useless headers)
rankings <- res %>% html_nodes("table") %>%
            .[2:6] %>% html_table(fill=TRUE)
# bind the dfs in the list
rankingsAll <- bind_rows(rankings)
# set var names and remove first row
names(rankingsAll) <- rankingsAll[1,]
rankingsAll <- rankingsAll[-1,]

# remove duplicated header rows
rankingsAll %<>% filter(ID!="ID")

# add a header row for the first table in the list
rankingsAll <- rankingsAll %>% add_row(ID="overall",.before=1)

# untangle2 function by J. Bryan
library(rlang)
library(tidyr)
# define fn
untangle2 <- function(df, regex, orig, new) {
  orig <- enquo(orig)
  new <- sym(quo_name(enquo(new)))
  
  df %>%
    mutate(
      !!new := if_else(grepl(regex, !! orig), !! orig, NA_character_)
    ) %>%
    fill(!! new) %>%
    filter(!grepl(regex, !! orig))
}

# untangle the header rows
rankingsCat <- rankingsAll %>% untangle2(regex = "[A-Za-z]",orig = ID, new= category)
## subset the overall rankings
# (the same dogs are ranked overall and within the other categories)
overallRank <- rankingsCat %>% filter(category=="overall")


## plotting
library(ggplot2)
library(beeswarm)
library(janitor)
library(ggalt)
library(forcats)
library(hrbrthemes)

# clean var names (spaces and such)
overallRank %<>% clean_names() 

# keep only breeds with 35 or more entries and create metric jump distance variable
overallRankSub <- 
  overallRank%>% group_by(dog_breed) %>% filter(n()>=35) %>% ungroup() %>% 
  mutate(jumpDist=((as.numeric(avg_feet)*30.48+as.numeric(avg_inches)*2.54)/100))

# beeswarm object
dogbees <- beeswarm(jumpDist~dog_breed,method="swarm",data=overallRankSub,vertical=FALSE,
         side=1)#, corral="gutter")
# rename vars
dogbees %<>% rename(jumpDist=y, dens=x, breed=x.orig)
# scale beeswarm density
dogbees %<>% group_by(breed) %>% mutate(scDens=(dens-min(dens)) / (max(dens)-min(dens))) %>% ungroup()

# reorder so breeds are arranged by median jump distance
# as a new variable
dogbees$breedR <- fct_reorder(dogbees$breed,dogbees$jumpDist,fun=median,.desc=TRUE)

# presummarize median jump distances
medJumps <- dogbees %>% group_by(breedR) %>% summarise(med=median(jumpDist))

# data frame for the geom_text labels
bdata = data.frame(x=0.25, y=0.85, 
                  lab=levels(fct_reorder(dogbees$breed,dogbees$jumpDist,fun=median,.desc=TRUE)),
                  breedR=levels(fct_reorder(dogbees$breed,dogbees$jumpDist,fun=median,.desc=TRUE)))

# plot
ggplot(dogbees)+
    geom_bkde(aes(x=jumpDist,y=..scaled..), color="#0684D0",
            truncate=FALSE, fill="#D1D5DB",alpha=0.5,
            range.x = c(0,max(dogbees$jumpDist)))+
  geom_point(aes(x=jumpDist,y=scDens),
             pch=21, color="white",fill="#231F20",size=2)+
  geom_vline(data=medJumps,aes(xintercept=med),color="light grey")+
  labs(x="Big Air® jump distance (meters)", y="density (scaled)",
       caption="source: DockDogs.com Worldwide Rankings \n *retrieved* 09/07/2017")+
  scale_y_continuous(breaks = c(0,1),expand = c(0,0))+
  scale_x_continuous(expand=c(0,0))+
  facet_grid(breedR~.,scales = "free")+
  theme_minimal(base_family = "Roboto Condensed")+
  theme(strip.text.y = element_blank(),
        panel.grid = element_blank(),
        axis.title = element_text(size=rel(1.4)),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size=rel(1.3), color = "#020816"))+
  geom_text(aes(x, y, label=lab),data=bdata, hjust=0)

##############################################
# repeat with larger subsets

# reclassify into retrievers, mixed, other
overallRankReClass<- 
    overallRank%>% 
      mutate(breedRC= case_when(grepl("retriever",dog_breed, ignore.case=TRUE)~"retriever",
                          !grepl("retriever|mixed",dog_breed,ignore.case = TRUE) ~ "other",
                          TRUE ~ "mixed"),  
              jumpDist=(as.numeric(avg_feet)*30.48+as.numeric(avg_inches)*2.54)/100)

# beeswarm object
dogbeesrc <- beeswarm(jumpDist~breedRC,method="swarm",data=overallRankReClass,vertical=FALSE,
                    side=1, corral="gutter")
# rename vars
dogbeesrc %<>% rename(jumpDist=y, dens=x, breedRC=x.orig)
# scale beeswarm density
dogbeesrc %<>% group_by(breedRC) %>% mutate(scDens=(dens-min(dens)) / (max(dens)-min(dens))) %>% ungroup()

# reorder so breeds are arranged by median jump distance
# as a new variable
dogbeesrc$breedRCr <- fct_reorder(dogbeesrc$breedRC,dogbeesrc$jumpDist,fun=median,.desc=TRUE)

# presummarize median jump distances
medJumpsrc <- dogbeesrc %>% group_by(breedRCr) %>% summarise(med=median(jumpDist))

# data frame for the geom_text labels
bdatarc = data.frame(x=0.25, y=0.85, 
                   lab=levels(fct_reorder(dogbeesrc$breedRC,dogbeesrc$jumpDist,fun=median,.desc=TRUE)),
                   breedRCr=levels(fct_reorder(dogbeesrc$breedRC,dogbeesrc$jumpDist,fun=median,.desc=TRUE)))

# plot
ggplot(dogbeesrc)+
  geom_bkde(aes(x=jumpDist,y=..scaled..), color="#0684D0",
            truncate=FALSE, fill="#D1D5DB",alpha=0.5,
            range.x = c(0,max(dogbeesrc$jumpDist)))+
  geom_point(aes(x=jumpDist,y=scDens),
             pch=21, color="white",fill="#231F20",size=2)+
  geom_vline(data=medJumpsrc,aes(xintercept=med),color="light grey")+
  labs(x="Big Air® jump distance (meters)", y="density (scaled)",
       caption="source: DockDogs.com Worldwide Rankings \n *retrieved* 09/07/2017")+
  scale_y_continuous(breaks = c(0,1),expand = c(0,0))+
  scale_x_continuous(expand=c(0,0))+
  facet_grid(breedRCr~.,scales = "free")+
  theme_minimal(base_family = "Roboto Condensed")+
  theme(strip.text.y = element_blank(),
        panel.grid = element_blank(),
        axis.title = element_text(size=rel(1.4)),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size=rel(1.3), color = "#020816"))+
  geom_text(aes(x, y, label=lab),data=bdatarc, hjust=0)




##############################################
# repeat with larger subsets
# for ages

overallRankAg<- 
  overallRank%>% mutate(
         jumpDist=(as.numeric(avg_feet)*30.48+as.numeric(avg_inches)*2.54)/100)

# beeswarm object
dogbeesag <- beeswarm(as.numeric(dog_age)~category,method="swarm",data=overallRankAg,vertical=FALSE,
                      side=1, corral="gutter")
# rename vars
dogbeesag %<>% rename(dogAge=y, dens=x)
# scale beeswarm density
dogbeesag %<>% mutate(scDens=(dens-min(dens)) / (max(dens)-min(dens))) 

# plot
ggplot(dogbeesag)+
  geom_bkde(aes(x=dogAge,y=..scaled..), color="#0684D0",
            truncate=FALSE, fill="#D1D5DB",alpha=0.5,
            range.x = c(0,max(dogbeesag$dogAge)))+
  geom_point(aes(x=dogAge,y=scDens),
             pch=21, color="white",fill="#231F20",size=2)#+
  labs(x="Big Air® jump distance (meters)", y="density (scaled)",
       caption="source: DockDogs.com Worldwide Rankings \n *retrieved* 09/07/2017")+
  scale_y_continuous(breaks = c(0,1),expand = c(0,0))+
  scale_x_continuous(expand=c(0,0))+
  theme_minimal(base_family = "Roboto Condensed")+
  theme(strip.text.y = element_blank(),
        panel.grid = element_blank(),
        axis.title = element_text(size=rel(1.4)),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size=rel(1.3), color = "#020816"))+
  geom_text(aes(x=0.5, y=1, label="all dogs"),hjust=0)

# again without facetsgeom

ggplot(dogbees)+
  geom_joy(aes(x=jumpDist,y=breedR,group=breedR, height=..density..),scale=3)

transform(dogbees, ymin = y, ymax = y + iscale*params$scale)

ggplot(dogbees)+
  geom_joy(aes(x=jumpDist,y=breedR,group=breedR, height=..density..),scale=1.9)+
  geom_joyswarm(aes(x=jumpDist,y=dens,group=breedR),
             pch=21, color="white",fill="#231F20",size=2)


    
  geom_bkde(aes(x=jumpDist,y=..density..,group=breedR), color="#0684D0",
            truncate=FALSE, fill="#D1D5DB",bandwidth = 0.25,alpha=0.1,
            range.x = c(0,max(dogbees$jumpDist)))#+
  geom_vline(data=medJumps,aes(xintercept=med),color="light grey")+
  labs(x="Big Air® jump distance (meters)", y="density (scaled)",
       caption="source: DockDogs.com Worldwide Rankings \n *retrieved* 09/07/2017")+
  scale_y_continuous(breaks = c(0,1),expand = c(0,0))+
  scale_x_continuous(expand=c(0,0))+
  facet_grid(breedR~.,scales = "free")+
  theme_minimal(base_family = "Roboto Condensed")+
  theme(strip.text.y = element_blank(),
        panel.grid = element_blank(),
        axis.title = element_text(size=rel(1.4)),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size=rel(1.3), color = "#020816"))+
  geom_text(aes(x, y, label=lab),data=bdata)



devtools::install_github("clauswilke/ggjoy")
library(ggjoy)
diamonds

ggplot(dogbees,aes(x=jumpDist,y=breedR, group=breedR, height=..density..))+
  geom_joy(scale=2, fill="#D1D5DB",color="#0684D0") +
  scale_y_discrete(expand=c(0,0)) +
  scale_x_continuous(expand=c(0,0))+
  labs(x="Big Air® jump distance (meters)", y="density",
       caption="source: DockDogs.com Worldwide Rankings \n *retrieved* 09/07/2017")+
  theme_ipsum(axis_text_size = 11, axis_title_size = 14)+
  theme(axis.text.x = element_text(color = "#020816"))
  
  geom_joy()
#geom_point(aes(),
             pch=21, color="white",fill="#231F20",size=2)
  
ggplot(diamonds, aes(x=price, y=cut, group=cut, height=..density..)) +
  geom_joy(scale=4) +
  scale_y_discrete(expand=c(0,0)) +
  scale_x_continuous(expand=c(0,0))  
 
# iris <- iris
  iris2 <- data.frame(iris, family = c(rep(rep(1:2,25),3)))
  iris3 <- data.frame(iris2, group = paste(iris2$Species, iris2$family, sep = "_"))
  
  intercept <- plyr::ddply(iris3, .(group), function(x)  coefficients(lm(Petal.Length~Petal.Width,x)))
  rcarre <- plyr::ddply(iris3, .(group), function(x) summary(lm(Petal.Length~Petal.Width,x))$r.squared) 
  
  names(rcarre) <- c("group", "R2") 
  names(intercept) <- c("group", "intercept", "slope") 
  coefs <- merge(intercept, rcarre) 
  coefs <- data.frame(coefs,
                      eq = paste("Y=",round(coefs$intercept,2),"+",round(coefs$slope, 2),"x",", ","R2=",round(coefs$R2,2), sep = ""))
  coefs$eq = as.character(coefs$eq)
  
  iris4 <- merge(iris3, coefs)    
      ggplot(iris4, aes(x = Petal.Width, y = Petal.Length, colour = Species)) +
    geom_point() +
    geom_smooth(method=lm, se=F) +
    facet_grid(family~Species) +
    geom_text(aes(label=eq, x=1.5, y=6), data = dplyr::distinct(iris4, eq, .keep_all = TRUE)) +
    theme_linedraw()     
    
    
  theme_minimal()+
  theme(strip.text.y = element_blank())

geom_point(aes(x=dens)+
             
scale(dogbees$jumpDist)


ggplot(dogbees)+
  stat_bkde(aes(y=x))+
  geom_point(aes(y,scale(x)))+
  facet_grid(x.orig~.,scales = "free")

#geom_point()+

library(KernSmooth)  
  
data(geyser, package="MASS")

gey <- ggplot(geyser, aes(x=duration)) + 
  stat_bkde(alpha=1/2)
  
# subset retriever
retrievers <- overallRank %>%  filter(grepl("retriever", dog_breed, ignore.case=TRUE))

retrievers %<>% 



# alternative 
urlddogs <- "https://dockdogs.com/wp-admin/admin-ajax.php"
POST(url= urlddogs,
        body = list(action = "my_test_ajax_call", ranking_type = "1", 
                          event_type = "N", discipline = "1", filename = "rank", 
                          disciplinetxt = "", event_typetxt = "", seasontxt = "", 
                          designationtxt = "", season = "26"), encode = "form")

resp<-POST(urlddogs, body=fd, encode="form")
pg <- read_html(content(resp, as="text", encoding = "UTF-8"))

  pg
resp

content(resp)
resp$content



pg



pg %>% html_node("td")

reqd <- submit_form(session=pgsession, form=filled_form)
submit_form()




library(httr)
library(rvest)
library(purrr)
library(dplyr)
  
res <- POST("https://dockdogs.com/rankings-results/rankings",
              body = list(ranking_type = "Worldwide Ranking",
                          event_type = "National",
                          discipline  = "Big Air"), 
              encode = "form")

pg <- read_html(content(resp, as="text", encoding="UTF-8"))
  
map(html_nodes(pg, xpath=".//td"), ~html_nodes(., xpath=".//text()")) %>% 
    map_df(function(x) {
      map(seq(1, length(x), 2), ~paste0(x[.:(.+1)], collapse="")) %>% 
        trimws() %>% 
        as.list() %>% 
        setNames(sprintf("x%d", 1:length(.)))
    }) -> right
  
#left <- html_nodes(pg, "div.tiendas_resultado_left") %>%  html_text()
  
#df <- bind_cols(data_frame(x0=left), right)
  
  glimpse(df)
  
  
  
url <- "http://www.footballoutsiders.com/stats/snapcounts"
pgsession <- html_session(url)
pgform <-html_form(pgsession)[[3]]
filled_form <-set_values(pgform,
                           "team" = "ALL",
                           "week" = "1",
                           "pos"  = "ALL",
                           "year" = "2015"             
  )


filled_form$fields

