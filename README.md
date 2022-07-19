# og:image

This action dynamically generates Open Graph images (OG:Image) from template files. This is useful for giving your links more context on social media such as Twitter and LinkedIn.

With some CSS finesse, you too can auto-generate your own OG images like GitHub does.

<center><img src="https://opengraph.githubassets.com/f1ac5cee6a934fa04d2fc7fbd76084a5343347798d1e9213d9c367eeecf73761/dataplat/dbatools"></center>

So when people posts links to your site, they are informative and look great:

<center><img src="https://user-images.githubusercontent.com/8278033/179485407-b721d755-92f2-4850-82b0-9a019c0b1917.png"></center>

This action uses [pandoc](https://pandoc.org/) to convert the files into an all-in-one webpage and [Microsoft Playwright](https://github.com/microsoft/playwright) to take a "screenshot" which is a 1200x630 image.

## How does it work?

Basically, you **create a markdown or html template** with phrases to replace like `--AUTHOR--` or `--TITLE--`.

```
<div class="title">--TITLE--</div>
<div class="author">A new article by --AUTHOR--!</div>
```

Then let the action know what --AUTHOR-- and --TITLE-- will be replaced by.

```
@{
    "--TITLE--"     = "New book released!"
    "--AUTHOR--"    = "Chrissy LeMaire"
}
```

Want to make it pretty? You can even attach a stylesheet or reference an online stylesheet or both.

Keep in mind that the generated image is 1200x630 so your stylesheet or general design should accommodate that size.

## Documentation

To dynamically generate your own image, just copy the code below and modify as desired. I know I just want to see stuff work, so it works without any modifications, right out of the box.

```yaml
    - name: Generate Open Graph Image
      uses: potatoqualitee/ogimage@v1.0
      with:
        stylesheet: ./sample/style.css
```

Once that runs, check the Actions tab in your repo, then download the artifact to see your image.

You can also get a lot more advanced too.

```yaml
    - name: Generate Open Graph Image
      uses: potatoqualitee/ogimage@v1.0
      with:
        template-path: ./blog/assets/template.md
        stylesheet: ./blog/assets/template-style.css, https://fonts.googleapis.com/css?family=Ubuntu
        hashtable: |-
          @{
              "FileName"          = "my-files"
              "--TITLE--"         = "This can be anything"
              "--AUTHOR--"        = "Anyone"
              "--SYNOPSIS--"      = "All of these variable names and replacement values are just made up"
              "--FOOTER--"        = "Copyright 1998"
          }
        output-path: ./gh-pages/images
```

If you'd like to see it work before diving in, this example works:

```yaml
      - name: Generate Open Graph Image
        uses: potatoqualitee/ogimage@v1.0
        with:
          stylesheet: ./sample/style.css
          hashtable: |-
            @{
                "FileName"          = "rbar-performance-in-powershell"
                "--TITLE--"         = "RBAR Performance in PowerShell"
                "--AUTHOR--"        = "By Chrissy LeMaire"
                "--SYNOPSIS--"      = "In this article, we'll cover looping performance for PowerShell."
                "--FOOTER--"        = "See more at netnerds.net"
            }
```

The output is a file named `rbar-performance-in-powershell.png` which looks like this

![image](https://user-images.githubusercontent.com/8278033/179579774-671d6dc7-e49f-4e19-9456-f3a5108e496b.png)

I'm not so good at CSS and HTML so it could be better, but this shows you how it can work. Here are the sample files I used.

* [/sample/template.md](https://raw.githubusercontent.com/potatoqualitee/ogimage/main/sample/template.md)
* [/sample/style.css](https://github.com/potatoqualitee/ogimage/blob/action/main/style.css)


For multiple images, you will want to specify a hashtable-filename such as `./assets/hash.ps1` that contains code formatted similar to the following:

```
@(
    @{
        "FileName"         = "MyPic"
        "--TITLE--"        = "Sample Title"
        "--AUTHOR--"       = "Foster Jones"
        "--SYNOPSIS--"     = "This too"
        "--FOOTER--"       = "Footer sample"
    },
    @{
        "FileName"         = "My Second Pic"
        "--TITLE--"        = "Another Title"
        "--AUTHOR--"       = "Adam Pie"
        "--SYNOPSIS--"     = "And this too"
        "--FOOTER--"       = "Another footer sample"
    }
)
```

Once the file is created and stored in your repo, specify it as a `filename`


```yaml
      - name: Generate Open Graph Image
        uses: potatoqualitee/ogimage@v1.0
        with:
          stylesheet: ./sample/style.css
          hashtable-filepath: ./sample/replace-template.ps1
```

To add it to your website, copy the images to an appropriate directory, edit the html output of your webpage and add the following code in your `<head>`.

```
<meta property="og:type" content="article" />
<meta property="og:title" content="dbatools docs:  Add-DbaAgDatabase" />
<meta property="og:url" content="https://docs.dbatools.io/Add-DbaAgDatabase.html" />
<meta property="og:description" content="dbatools docs for Add-DbaAgDatabase" />
<meta property="og:site_name" content="docs.dbatools.io" />
<meta property="og:locale" content="en_US" />
<meta property="og:image" content="https://docs.dbatools.io/assets/thumbs/Add-DbaAgDatabase.png">

<meta name=twitter:title content="dbatools docs:  Add-DbaAgDatabase">
<meta name=twitter:creator content="@psdbatools">
<meta name="twitter:site" content="@psdbatools" />
<meta name="twitter:image" content="https://docs.dbatools.io/assets/thumbs/Add-DbaAgDatabase.png">
<meta name="twitter:card" content="summary_large_image"> 
```


## Usage

### Pre-requisites
Create a workflow `.yml` file in your repositories `.github/workflows` directory. An [example workflow](#example-workflow) is available below. For more information, reference the GitHub Help Documentation for [Creating a workflow file](https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file).

### Inputs

* `template-path` - The path to the html or markdown to use as a template.
* `stylesheet` - A comma-separated list of paths to any CSS files you'll be using. Can include file paths and even web addresses.
* `hashtable` - A hashtable of key/value pairs to replace in the template. Use a FileName key (without an extension) to specify the filename to use for the image, otherwise, it'll be saved with a temporary name.
* `hashtable-filepath` - If you'd prefer to use an external PowerShell file to create your images instead of a hardcoded hashtable in YAML, you can use this to specify the filepath to use. This file should only contain a hashtable and start with `@{`
* `output-path` - The output path where the generated images will be saved. This will generally be your website's repository. By default, however, it'll save all output to /tmp/pics.
* `no-artifact` - By default, the markdown, html and png files are saved as an artifact. Set to true to skip the upload.
* `no-optimize` - Don't optimize the png (greatly decreases size but takes a bit).

### Cache scopes
The cache is scoped to the key and branch. The default branch cache is available to other branches. 

### Example workflows

Using pwsh on Ubuntu

```yaml
on: [push]

jobs:
  run-on-linux:
    runs-on: ubuntu-latest
    steps:
      - uses: potatoqualitee/ogimage@v1.0
      - name: Create OG:Images
        uses: ./

```

Using powershell on Windows. pwsh also works and is the default.

```yaml
on: [push]

jobs:
  run-on-linux:
    runs-on: ubuntu-latest
    steps:
      - uses: potatoqualitee/ogimage@v1.0
      - name: Create OG:Images
        uses: ./

      - name: Show that the Action works
        shell: pwsh
        run: |
          Get-ChildItem /tmp/pics | Select-Object FullName
```

## Contributing
Pull requests are welcome!

## License
The scripts and documentation in this project are released under the [MIT License](LICENSE)
