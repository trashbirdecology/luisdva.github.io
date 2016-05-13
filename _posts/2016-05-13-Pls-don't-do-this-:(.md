---
published: false
---


Easy changes to make before sharing tablular data with others

In the past month I’ve been busy with collaborations, and by coincidence all the projects that I’m involved with reached the stage of actually having completed datasets. This has involved me receiving data via email or shared web folders. So far all these data has come in Excel spreadsheets. Personally, I don’t have anything against xls files and I won’t start judging others. However, with this post I want to share three common spreadsheet practices that we should all avoid when preparing and sharing data in a tabular format. These are all things I’ve done in the past, but they add complication and slow things down at the time of analysis and data manipulation.
Obviously there are workarounds and fancy ways to solve the complications programmatically but I won’t get into that here. It’s easier if those with the original data avoid messy spreadsheet practices from the very start.
1 color coding and other formatting
Spreadsheet programs let us format cells and their content with different colors, borders, font types, etc. Highlighted cells are a good visual aid, and sometimes I use them but never when I plan on sharing the files with anyone else.
By doing this, whatever the color represents is stacked with the actual data in the cell, with no easy way to separate these two (or more) values. 
Example1
Suggestion: add additional columns with the information that was being conferred by the formatting. It might look redundant but it’s an incredible time saver and very convenient within scripting languages.
Example1.2

2. merged cells
Merged cells will look good in the final version of a table, but they can lead to strange behaviours when trying to read and manipulate the data with other programs. 
Example2
Suggestion: suck it up and repeat the content that was merged in the first place. R, Python and Julia can deal just fine with this kind of melted presentation of the data.
Example2.1
3. Weird header rows
This is a very common practice for data that follows some hierarchy. I see this often in papers from my field because this arrangement can convey geographic or taxonomic membership of different rows to whatever is referred to in the header row.
Ex3
Suggestion: Same as before, add a new column specifying the membership of each row.
Ex3.1
All the suggested changes make the tables less appealing visually, but they structure the data in a way that saves everyone time. 
