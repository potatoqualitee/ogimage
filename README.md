# og:image

This action dynamically generates Open Graph images (OG:Image) from mini little webpages. This is useful for giving your links more context on Twitter and more.

With some CSS finesse, you too can auto-generate your own OG images like GitHub does.

<center><img src="https://opengraph.githubassets.com/f1ac5cee6a934fa04d2fc7fbd76084a5343347798d1e9213d9c367eeecf73761/dataplat/dbatools"></center>

So when people post them online, they are informative and look great:

<center><img src="https://user-images.githubusercontent.com/8278033/179485407-b721d755-92f2-4850-82b0-9a019c0b1917.png"></center>

If you'd like to see how GitHub does it, you can check out their article: [A framework for building Open Graph images](https://github.blog/2021-06-22-framework-building-open-graph-images/).

## Documentation

Just copy the code below and modify as desired. I know I just want to see stuff work, so it works without any modifications, right out of the box.

```yaml
    - name: Install and cache PowerShell modules
      uses: potatoqualitee/ogimage@action
      with:
        stylesheet: ./sample/style.css
```

```yaml
    - name: Generate Open Graph Image
      uses: potatoqualitee/ogimage@action
      with:
        template-path: ./blog/assets/template.md
        stylesheet: ./blog/assets/template-style.css, https://fonts.googleapis.com/css?family=Ubuntu
        hashtable: |-
          @{
              "FileName"          = "rbar-performance-in-powershell"
              "--TITLE--"         = "RBAR Performance in PowerShell"
              "--BODY--"          = "In this article, we'll cover looping performance for PowerShell."
              "--WHATEVERELSE--"  = "By Chrissy LeMaire"
              "--FOOTER--"        = "See more at netnerds.net"
          }
```

## Usage

### Pre-requisites
Create a workflow `.yml` file in your repositories `.github/workflows` directory. An [example workflow](#example-workflow) is available below. For more information, reference the GitHub Help Documentation for [Creating a workflow file](https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file).

### Inputs

* `template-path` - The path to the html or markdown to use as a template.
* `stylesheet` - A comma-separated list of paths to any CSS files you'll be using. Can include file paths and even web addresses.
* `hashtable` - A hashtable of key/value pairs to replace in the template. Use a FileName key (without an extension) to specify the filename to use for the image, otherwise, it'll be saved with a temporary name.
* `hashtable-filepath` - If you'd prefer to use an external PowerShell file to create your images instead of a hardcoded hashtable in YAML, you can use this to specify the filepath to use. This file should only contain a hashtable and start with @{
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
      - uses: potatoqualitee/ogimage@action
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
      - uses: potatoqualitee/ogimage@action
      - name: Create OG:Images
        uses: ./

      - name: Show that the Action works
        shell: pwsh
        run: |
          Get-ChildItem /tmp/pics | Select-Object FullName
```

## Cache Limits
A repository can have up to 5GB of caches. Once the 5GB limit is reached, older caches will be evicted based on when the cache was last accessed.  Caches that are not accessed within the last week will also be evicted.

## Contributing
Pull requests are welcome!

## TODO
* Add support for additional custom repositories (may be out of scope?)

## License
The scripts and documentation in this project are released under the [MIT License](LICENSE)
