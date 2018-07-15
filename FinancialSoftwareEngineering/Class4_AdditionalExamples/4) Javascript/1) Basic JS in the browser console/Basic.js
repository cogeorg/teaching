// Some basic commands which we'll run in the Google Chrome console

// Prompt
alert("Hello, World")

// ---------------- Integers ---------------- //

// Addition
1 + 1

// Subtraction
4 - 2

// Multiplication
3 * 2

// Division
10 / 2

// Exponents
2 ** 3

// Modulo
9 % 4

// ---------------- Strings ---------------- //

"Hello, World"

// Indexing

a = "Hello, World";

a[0]

// Concatenation

"Hello" + "World"

// Escape characters

"line one \n line two"
"before tab \t after tab"

// Attributes

a.length

// Methods

a.includes(",")
a.toUpperCase()



// ---------------- Booleans ---------------- //

true
false

5 > 4


// ---------------- Other useful functionality ---------------- //

// Alert Pop-up
alert("hello world")

// print to console
console.log("Hello world")

//User inputs
prompt("What is your name")

//User inputs + alert

name = prompt("What is your name")
alert("Welcome " + name)

// ---------------- Control flow ---------------- //


// If else

var name = "John";

if (name == "Adam") {
    console.log("Hello Adam")
} else if (name == "John") {
    console.log("Hello John")
} else {
    console.log("Hello [insert name]")
}

// for

for (i = 0; i < 5; i = i + 1) {
    console.log(i);
}


for (i = 0; i < 5; i++) {
    console.log(i);
}

for (i = 0; i < a.length; i = i + 2) {
    console.log(i);
}

// While

var sum_of_series = 0;

while (sum_of_series < 10) {
    console.log('sum_of_series is currently: ', sum_of_series)
    sum_of_series += 1
}

// ---------------- Functions ---------------- //

function hello() {
    console.log("Hello, World");
}

hello()

function squareMe(num1) {
    console.log(num1 ** 2);
}

squareMe(0)
squareMe(5)

function squareMe(num1) {
    return num1 ** 2;
}

squareMe(5)

// ---------------- Arrays ---------------- //


var my_array = ["John", 5, true, "Sally"]; // Arrays in JS can store different types of data
my_array[0]

my_array.length // Array attributes

my_array.includes("John") // Array methods

for (var i = 0; i < my_array.length; i++) { //Loop over array
    console.log(my_array[i])
}

// ---------------- Objects ---------------- //


var my_cat = { name: "Garfield", color: "Orange" };
my_cat.name

var my_cat = {
    name: "Garfield",
    color: "Orange",
    meow: function() {
        console.log("Meow")
    }
};

my_cat.meow()

var my_cat = {
    name: "Garfield",
    color: "Orange",
    meow: function() {
        console.log("Meow, my name is " + this.name)
    }
};

my_cat.meow()