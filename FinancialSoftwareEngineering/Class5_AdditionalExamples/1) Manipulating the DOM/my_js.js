// When our HTML document renders in the browser it automatically generates the DOM
// We can now access the dom itself, via the object 'document'
// We can USE various methods on the document class to extract certain elements from HTML
// We can then interact with those elements directly, using JS to change HTML and CSS

// DOM methods

// A range of DOM methods exists, we'll focus on 3
// document.getElementById() -> Returns the element with the a specific id
// document.querySelector() -> Returns the first object matching the CSS style selector
// document.querySelectorAll() -- Returns all objects matchin the CSS style selector

// Let's access a specific html list elements through a tag which we've specified in the HTML file
// We use the getElementById of the document class to collect all elements with the ID "my_list"

var my_list_element = document.getElementById("my_list")

// Now that we have this element, we can change it
// Firstly, we can change the text, by changing the attribute innerText

my_list_element.innerText = "I've changed my list item"

// Secondly, we can change the HTML in that tag directly using the attribute innerHTML
// This way, we can now edit the appearance of the content in our ID tag

my_list_element.innerHTML = "<strong>I've changed my list item to bold</strong>"

// Using pure JS, we've been able to change the content in our HTML file!
// This is the power of the DOM

// Next, let's explore the querySelector methods
// Returns the first element corresponding to a CSS style
// In this case, we grab the first header iteM

var header = document.querySelector("h1")

// We change the background color
// Note here, since we are interacting with a CSS style, we can now access "style" and all of it's associated attributes
// We can change the background

header.style.background = "green"

// Remove the change

header.style.background = ""

// As before, edit the content

header.innerText = "I've changed the header"
header.innerHTML = "<em>I've changed the header to italics</em>"

// Note however that when we use querySelector we can only access the first occurance
// Let's try and change all of the paragraphs

var para = document.querySelector("p")
para.innerText = "Changed paragraph"

// This only changes the first occurance of a paragraph

var paras = document.querySelectorAll("p")

// This now returns a list of all of our paragraphs

paras

// We can now use indexing to access specific paragraphs

paras[1].innerText = "I've also changed"

// We can also access the DOM using functions
// Let's write a function to change the color

function changeColor(){
	var colors = ["Green", "Red", "Blue", "Black"]
	// we use the random method from the Math class to generate random numbers
	// We then bound these numbers at 4 and round them down
	// This gives us numbers between 0 and 3
	var color = colors[Math.floor(Math.random()*4)]
	header.style.color = color
}

// Now let's tell JS to change the color every second

setInterval("changeColor()",1000);
