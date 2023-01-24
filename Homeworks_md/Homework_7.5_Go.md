# devops-netology
### Желобанов Егор DEVOPS-21

# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

### Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

#### Ответ:
Установил `golang` с официального сайта, результат вывода команды `go version`:
```shell
egor@netology:~$ go version
go version go1.19.4 linux/amd64
```

### Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  

#### Ответ:
Ознакомился, поэкспериментировал с различными примерами.

### Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)    
    }
    ```
 
2. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```
3. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

В виде решения ссылку на код или сам код. 

#### Ответ:
1. Написал программу для перевода метров в футы, [файл calc.go прилагаю](/practice/07.5/calc.go):
```
package main

import "fmt"

func main() {
	fmt.Print("Введите длину в метрах: ")
	var meters float64
	fmt.Scanf("%f", &meters)
	futs := meters * 3.2808

	fmt.Printf("%v метров равно %v футов.\n", meters, futs)
}
```  
2. Написал программу, которая выводит наименьший элемент списка, [файл minimum.go прилагаю](/practice/07.5/minimum.go):
```
package main

import (
   "fmt"
   "sort"
)

func main() {
	x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
        sort.Ints(x)

	fmt.Printf("Наименьший элемент - %v\n", x[0])
}
```  
3. написал программу, выводящую числа от 1 до 100, которые делятся на 3, [файл three.go прилагаю](/practice/07.5/three.go):
```
package main

import "fmt"

func main() {
    for i := 1; i <= 100; i++ {
      if (i%3) == 0 {
        fmt.Print("[",i,"]\n")
      }
    }
}
```  