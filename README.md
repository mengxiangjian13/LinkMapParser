# LinkMapParser
iOS LinkMap file parser

## LinkMap file
LinkMap file is a large file containing the information about the app's executable file. When we want to optimize app's size, the LinkMap file is a good way to analyze the executable file. But usually LinkMap file is too large to analyse. So I wrote this tool to help us.

## Can do what?
This parser can show all files in your project and show the executable size of each file, including the 3rd party library. The biggest file or library will show on top, so you can decide which part of code will be optimized.
