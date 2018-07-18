// We'll now see how we can use jQuery to simplify our interactions with the DOM
// jQuery's major advantage comes through the use of the $
// The $ effectively replaces methods like querySelector

// Typing $ into the console, we see that $ represents a selector
$

// With base JS, to select our list item with the list id, we would do one of the following

var my_list_element = document.getElementById("my_list")

// or

var my_list_element = document.querySelector("#my_list")

// Using jQuery, we can use the following syntax

var my_list_element = $("#my_list");

// The $ saves us from having to call document.getElementById or document.querySelector

// now using jQuery, we can easily change the text
// In base JS

my_list_element.innerText = "I've changed my list item"

// Using jQuery

my_list_element.text("I've changed my list item using jQuery")

// To change the HTML

my_list_element.html("<strong>I've changed my list item using jQuery</strong>")

// Previously, when we wanted to change the CSS, say the color, we'd have to do the following

var header = document.querySelector("h1")
header.style.color = "Green"

// Now using jQuery

var header = $("h1")
header.css("color", "Red")

// jQuery's css function is particularly useful here
// It tells us clearly we are changing CSS and allows us to pass the css attribute and value we choose as parameters
// Another useful feature of jQuery is the ability to change multiple CSS attributes at once

var newCSS = {
  "color":"Blue",
  "background":"Gray"
}

header.css(newCSS);

// We can also index using JS
// Say we grabbed all the paragraphs and wanted to specifically select the second paragraph
// In base JS

var para = document.querySelectorAll("p")
para[1].style.color = "Green"

// Using jQuery

var para = $("p")
para.eq(1).css('color','Red');

