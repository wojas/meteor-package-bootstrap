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

