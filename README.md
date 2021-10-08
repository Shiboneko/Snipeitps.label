# SnipeITPS.Label

Contains a module to print labels, based on snipe-it Assets
This repository is only a small example, of how you can achieve this.
Feel free to fork, share or modify the code.


# How does it work
You need the *Zebra Designer Essentials* to create the labels.
I've added an example Label für 1" by 3" labels in the file format .nlbl
The text with {{tag}} is where my script will replace the values. Add your own, if you need more infos on your labels.

To get a good example, use the snipeitps module with `Get-SnipeitAsset -search <asset_tag>`

Once you have created your label print it as a file. In the print menu of the zebra designer, there is a checkbox.
The fileformat for the printed file is .prn. Check it out. It's just a textfile. You could also write this file yourself by following the ZPLII Programming Guide from Zebra directly
The final file should be placed in the labels folder.

Inside the `Print-SnipeItLabel.ps1` file, you will find a few default values.
Replace those or leave them.

To finally print the the label, use the command `Print-SnipeItLabel <asset_tag> -Printer ZPR12345678 -Label example-label.prn`




