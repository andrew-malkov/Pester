<#
In order to avoid silly mistakes
As a math idiot
I want to be told the sum of two numbers
#>
Scenario "Add two numbers" {

	Given "I have entered 50 into the calculator" {
		$summand1 = 50
	}

	And "I have entered 70 into the calculator" {
		$summand2 = 70
	}
	
	When "I press add" {
		$result = $summand1 + $summand2
		throw "something bad occurred"
	}
	
	Then "The result should be 120 on the screen" {
		$result | Should Be 120
	}
}