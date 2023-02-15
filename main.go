package main

import (
	"fmt"

	"github.com/rbroggi/binarycov/greetings"
	"rsc.io/quote"
)

func main() {
	fmt.Printf("I say %q and %q\n", quote.Hello(), greetings.Goodbye())
}
