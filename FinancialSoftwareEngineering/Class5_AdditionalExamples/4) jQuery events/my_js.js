// The last component we'll look at is how we can use jQuery for event handling
// We can perform actions on certain events like say clicks

$('#my_header1').click(function(){
  console.log("Something happened! A click!");
})

//In order to change things like text and html, we'll use our friend, this

$('#my_header2').dblclick(function() {
  $(this).text("I was changed using this, and jQuery");
})

$('#my_header3').mouseenter(function() {
  $(this).text("Cursor is hovering");
})


$('#my_header3').mouseleave(function() {
  $(this).text("Third header");
})

// If you however prefer the addEventListener syntax, jQuery accomodates this too
// Using on() which effectively replicates the addEventListener syntax

$('#my_header1').on("click",function() {
  $('#my_header1').css("color", "Red");
})

// jQuery also gives us a range of additional functionality
// We could for example add effects

$('#my_header2').dblclick(function() {
  $(this).hide(2000)
})

$('#my_header3').click(function() {
  $(this).hide(2000, function(){
  	alert("You've hidden a paragraph")
  })
})


