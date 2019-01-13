function Add-Numbers {
    Param(
        [int[]]$Numbers
    )
    $Total = [int]0
    foreach($Number in $Numbers) {
        $Total += $Number
    }
    return $Total
}

$PizzasEaten = [int]0

$PizzasEaten = Add-Numbers(2,5,10)

$Message = "Pizzas so far $PizzasEaten"
Write-Output $Message

$PizzasEaten = Add-Numbers($PizzasEaten,3)

$Message = "Final pizzas eaten $PizzasEaten"
Write-Output $Message