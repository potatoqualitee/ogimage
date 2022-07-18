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
    - name: Install and cache PowerShell modules
      uses: potatoqualitee/ogimage@action
      with:
        template-path: ./blog/assets/template.md
        stylesheet: ./blog/assets/template-style.css, https://fonts.googleapis.com/css?family=Ubuntu
        hashtable: |-
          @{
              "FileName"          = "-thumbnail"
              "--TITLE--"         = "Sample Title"
              "--BODY--"          = "Sample body"
              "--WHATEVERELSE--"  = "This too"
              "--FOOTER--"        = "Footer sample"
          }
```

## Usage

### Pre-requisites
Create a workflow `.yml` file in your repositories `.github/workflows` directory. An [example workflow](#example-workflow) is available below. For more information, reference the GitHub Help Documentation for [Creating a workflow file](https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file).

### Inputs

* `modules-to-cache` - A comma separated list of PowerShell modules to install or cache.
* `shell` - The default shell you'll be using. Defaults to pwsh. Options are `pwsh`, `powershell` or `pwsh, powershell` for both pwsh and powershell on Windows.
* `allow-prerelease` - Allow prerelease during Save-Module. Defaults to true.
* `force` - Force during Save-Module. Defaults to true.

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
    - uses: actions/checkout@v2
    - name: Install and cache PowerShell modules
      id: psmodulecache
      uses: potatoqualitee/psmodulecache@v4.5
      with:
        modules-to-cache: PSFramework, PoshRSJob, dbatools:1.0.0
    - name: Show that the Action works
      shell: pwsh
      run: |
          Get-Module -Name PSFramework, PoshRSJob, dbatools -ListAvailable | Select Path
```

Using powershell on Windows. pwsh also works and is the default.

```yaml
on: [push]

jobs:
  run-on-windows:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v2
    - name: Install and cache PowerShell modules
      id: psmodulecache
      uses: potatoqualitee/psmodulecache@v4.5
      with:
        modules-to-cache: PSFramework, PoshRSJob, dbatools:1.0.0
    - name: Show that the Action works
      shell: pwsh
      run: |
          Get-Module -Name PSFramework, PoshRSJob, dbatools -ListAvailable | Select Path
          Import-Module PSFramework
```

Install for both powershell and pwsh on Windows.

```yaml
on: [push]

jobs:
  run-for-both-pwsh-and-powershell:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install and cache PowerShell modules
        id: psmodulecache
        uses: potatoqualitee/psmodulecache@v4.5
        with:
          modules-to-cache: PoshRSJob, dbatools
          shell: powershell, pwsh
      - name: Show that the Action works on pwsh
        shell: pwsh
        run: |
          Get-Module -Name PoshRSJob, dbatools -ListAvailable | Select Path
          Import-Module PoshRSJob
      - name: Show that the Action works on PowerShell
        shell: powershell
        run: |
          Get-Module -Name PoshRSJob, dbatools -ListAvailable | Select Path
          Import-Module PoshRSJob
```

## Cache Limits
A repository can have up to 5GB of caches. Once the 5GB limit is reached, older caches will be evicted based on when the cache was last accessed.  Caches that are not accessed within the last week will also be evicted.

## Contributing
Pull requests are welcome!

## TODO
* Add support for additional custom repositories (may be out of scope?)

## License
The scripts and documentation in this project are released under the [MIT License](LICENSE)
