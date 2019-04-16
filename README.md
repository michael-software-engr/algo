# Algorithms

This will create a binary search tree, create a Graphviz (dot) file representing the tree, then render that file to a PNG file.

# Requirements

You need to install Graphviz and its dev package. On Ubuntu, the package names are `graphviz` and `graphviz-dev`. I'm using `xviewer` to render the PNG file. If you're using a different program, you'll have to edit `binary_tree/utils/render.sh`.

# Docker

You can do `./docker/run.sh <ruby-file>` if you don't want to install `graphviz` and the other required software. You have to install docker though (see [instructions](https://docs.docker.com/install/)). This is only useful when running scripts that show visual display of data structures. These are typically the "runner" files. For example: `./docker/run.sh binary_tree/binary_search_tree/runner.rb`.

# TODO

Fix heap bug (tree display).
