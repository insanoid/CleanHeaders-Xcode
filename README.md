# CleanHeaders

An Xcode plug-in to format your import headers in a systematic manner. It simply removes duplicates, spaces and sorts them alphabetically making it much more easier to read and avoid duplidate imports. Works with `@imports`, `#include`, `#import` and `import`.

![Preview](https://raw.githubusercontent.com/insanoid/CleanHeaders-Xcode/master/diff_image.png)

## Installation

Install using [Alcatraz](https://github.com/mneorr/Alcatraz).

Alternatively you can also clone this repo, build and run CleanHeaders, restart Xcode.

## Usage

Press `command+|` to format the headers for the currently open file. You can also select a certain segment of the file and do the same.

## TODO/Limitations

- Works with includes kept together at the top of the file only.
- If there is a platform specific include such as `#if TARGET_OS_WATCH` the headers would have to be sorted seperately.
- Auto save option not available yet.
- Missing tests


I am using some helper functions to deal with the IDE from [ClangFormat-Xcode](https://github.com/travisjeffery/ClangFormat-Xcode), thanks for the awesome class.