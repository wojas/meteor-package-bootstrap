This script allows you to build a custom Meteor package from
Twitter's Bootstrap framework, from either a precompiled distribution,
or your own clone of the Bootstrap Git repository.

If you set the output directory to `$your_meteor_project/packages/bootstrap`,
it will override the core Meteor bootstrap package. The advantage of doing this
over using a custom package name is that third party packages depending
on bootstrap will have their dependency properly satisfied.

The structure of the generated Meteor package is the same as of the core
package.


## Usage

    cd $your_bootstrap_clone_or_download/
    /path/to/meteor-package-bootstrap.sh $your_meteor_project/packages/bootstrap 


## Using variables.less and mixins.less

The build script copies variables.less and mixins.less to your package directory,
so that you can use their definitions in your project.

Meteor will not automatically load these files. To import them, you need to add 
two lines similar these:

    @import "../packages/bootstrap/variables.less";
    @import "../packages/bootstrap/mixins.less";

The exact path depends on from where you are importing the files.


## Advantages over including the source files in your project

From my experience, it's a bad idea to directly include the Bootstrap LESS
files in a Meteor project:

* It will make your development environment a lot slower, as many extra files 
  need to be converted by Meteor and fetched by your browser.
* It does not satisfy dependencies of third party packages that explicitly 
  depend on the core bootstrap package. If you add one of those, you will end up 
  with two bootstraps in your project.
* Resources of packages are loaded earlier than project files. If you have an 
  external package extending bootstrap, it's styling will be loaded before 
  bootstrap.
* Having to rename all imports to end with .lessimport makes it hard to keep 
  up with newer bootstrap releases.
* The order in which the bootstrap javascript files are loaded by Meteor 
  (alphabetically) is incorrect, leading to Javascript errors that can only 
  be fixed by renaming the files.
