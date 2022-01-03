# **************************************************************************** #
#
#    Makefile
#    By: vab2048
#    Created: 2021/01/03
#                                                                              #
# **************************************************************************** #
#
# The Makefile automates simple tasks for the build of the final README.md. 
#
# We use the `doctoc` npm utility to automate the generation of a table of
# contents for the markdown file.
# **************************************************************************** #

main:
	doctoc --title '**Contents**' ./README.md

# Setup the environment.
# Requirements:
# - npm installed and on path
env:
	# Install doctoc globally (-g).
	# - This will autogenerate the table of contents (TOC hence "doctoc").
	# - We don't care about polluting the global (-g)
	npm install -g doctoc
