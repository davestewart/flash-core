# Flash Core

## Overview

Flash Core is a growing collection of ActionScript classes I use in every project.

The classes have been built and added to over the years, all in commercial projects, as generic solutions to specific problems.

They can be used as-is in much of your code, but are all thoughtfully designed to be built upon in whatever application you're building.
  
Some examples of classes in Flash Core are:

 - Containers, such as HBox, VBox, Stack, Slider, Viewport
 - Display classes, such as Preloader, ProgressBar, Waveform, Square, Circle
 - Media classes, such as Video, Audio, Image, LocalImage
 - Net classes, such as RestClient, PHPVariables
 - Data classes, such as Cookie, Validator, Settings, ObjectModel, XMLModel
 - Event classes, such as MediaEvent, ActionEvent, ValueEvent
 - Managers, such as ScrollManager, BaseBootstrap, TaskQueue
 - Tools, such as Draggable, Identifier, PixelMonitor, Marquee
 - Utilities, such as Colors, Elements, Layout, Strings, Styles

To see the live projects this library developed out of, check out my Flash work at:

 - [davestewart.co.uk/flash/](http://davestewart.co.uk/flash/)

## Usage

Flash Core is designed to sit within your `src` folder, in a locally-namespaced setup.

Typical project setup is as follows:

    +- project
         +- assets            // fla, fonts, etc
         +- bin               // deployment folder
         +- lib               // actionscript libraries
         +- src
         |   +- app           // application-specific code
         |   +- core          // this library
         |   +- dev           // development test code
         |   +- Main.as
         +- Project.as3proj

This results in 3 top-level namespaces for your project, siloing your development and intentions:

 - app
 - core
 - dev

A typical class in a project using Flash Core might be set out like so:

	package dev.media 
	{
		import flash.display.DisplayObjectContainer;
		import flash.events.MouseEvent;
		import flash.utils.setTimeout;
		
		import core.display.containers.boxes.HBox;
		import core.display.containers.boxes.VBox;
		import core.display.Document;
		
		import app.media.VideoPlayer;
		
		import dev.components.ui.Button;
		
		public class AppPlayerTest extends Document 
		{
			...

As you can see the introduction of top-level (non TLD-based) namespaces makes it much easier to grok a class' dependencies and role.

## Installation

You can install Flash Core either as a Git sub-module, or just download and unzip the files.

Note that the library's files **must** reside in a folder called `core` for the namespacing to work. 

### To install using Git sub-modules

1. Open a console window in the project folder that will contain the `core` folder
2. Run the following code `git submodule add git@github.com:davestewart/flash-core.git core`


### To install manually

1. Click "Download ZIP" in the top right of this page
2. Unzip to a project folder called `core` 


### IDE setup

Ensure one of your IDE's class paths point to the folder containing the `core` folder.

If you follow the project setup suggestion above, this will be `src`, but could just as well be `lib`.



## Examples
 
For examples of Flash Core in action, see the [Flash Core Demo](https://github.com/davestewart/flash-core-demo) repository.