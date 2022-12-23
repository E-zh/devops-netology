package main

import "fmt"

func main() {
	fmt.Print("Введите длину в метрах: ")
	var meters float64
	fmt.Scanf("%f", &meters)
	futs := meters * 3.2808

	fmt.Printf("%v метров равно %v футов.\n", meters, futs)
}