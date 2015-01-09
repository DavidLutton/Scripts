Versions

0. Mangled filenames, this was resolved with extracts from [stackoverflow](http://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash).
0. Worked but reoriented some blank pages, otherwise seemed fine.
0. Added commands in order to not prevent any rotation decisions. [ghostscript docs](http://ghostscript.com/doc/8.54/Ps2pdf.htm#Options)
0. With thanks to [stefaanlippens](http://stefaanlippens.net/pdf2ps_vs_pdftops) switched to pdftops. This is distinctly faster and less fussy with pdfs.
0. Some old pdfs result in a blank output, fixed by adding a [check](http://stackoverflow.com/a/5920355/3459491) for blank, _without content_, pdf and regenerate using the original method.
0. Works in directory no effect to original files.
0. Added a command that with some output processing can tell you about pdf security
0. Added a ghostscript processor that is less destructive
0. Branched all the processors so that they are ordered most to least effective
0. Found pdfcrack and these [instructions](http://www.cyberciti.biz/faq/removing-password-from-pdf-on-linux/) for removing limits with known passwords
0. Refactor : Resultant if if if if was too confusing, moved info functions and use return codes for flow control also subdir & spaces safe thanks to [stackoverflow](http://stackoverflow.com/a/1403489/3459491)
 

## Code ##
{% highlight bash %}
{% include_relative pdf_permisionstrip.sh %}
{% endhighlight %}


## results notes ##
All have no print security locking.  
All have no to minimal effects from reprocessing. Worst that I have seen is [Font rasterization](http://en.wikipedia.org/wiki/Font_rasterization)  


[ghostscript command](http://www.cyberciti.biz/faq/removing-password-from-pdf-on-linux/)  
[detect](http://stackoverflow.com/questions/14233756/remove-printing-protection-from-pasword-protected-pdf-files)  
[bash comparisons](http://tldp.org/LDP/abs/html/refcards.html)  
[file size check](http://stackoverflow.com/questions/5920333/how-to-check-size-of-a-file)  



## Bash ##
[exit code handle](http://stackoverflow.com/questions/5195607/checking-bash-exit-status-of-several-commands-efficiently)  
[case](http://www.thegeekstuff.com/2010/07/bash-case-statement/)  
