// We'll now add some reactivity to our HTML pages
// Specifically, we'll invoke invoke some changes in the HTML and CSS conditional on certain events
// To do this we'll use the addEventListener method

// Note, that instead of using getElementByID("my_header1"), we can use querySelector too
// Specifically, when we use a # before a name, we are telling querySelector to look for an item with the HTML ID my_header
// Since we need to access the CSS of my_header1, we need to use querySelector here

var headerOne = document.querySelector('#my_header1')
var headerTwo = document.querySelector('#my_header2')
var headerThree = document.querySelector('#my_header3')


// Now we add an event listener, that looks for when a user moves cursor over the element
// We pass two parameters
// 1) The event, in this case mouseover
// 2) The piece of code we want to execute, which we encase in a function
// In this case, we want to change the text and the color

headerOne.addEventListener('mouseover',function(){
  headerOne.textContent = "Hovered";
  headerOne.style.color = 'Red';
})

// Note that once we hover off the changes remain
// We now need to change reverse the changes when the cursor hovers off


headerOne.addEventListener('mouseout',function(){
  headerOne.textContent = "First header"
  headerOne.style.color = 'black';
})


// Now let's add a click event

headerTwo.addEventListener("click",function(){
  headerTwo.textContent = "Clicked me";
  headerTwo.style.color = 'Blue';
})

// Now let's add a doubleclick event


headerThree.addEventListener("dblclick",function(){
  headerThree.textContent = "Double Clicked!";
  headerThree.style.color = 'Green';
})




