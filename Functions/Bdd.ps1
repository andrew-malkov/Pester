function Scenario {
param(
        [Parameter(Mandatory = $true, Position = 0)] $name,
        $tags=@(),
        [Parameter(Mandatory = $true, Position = 1)]
        [ScriptBlock] $fixture
)
    $pester.Scope = "Describe"
    if($testName -ne '' -and $testName.ToLower() -ne $name.ToLower()) {return}
    if($pester.arr_testTags -ne '' -and @(Compare-Object $tags $pester.arr_testTags -IncludeEqual -ExcludeDifferent).count -eq 0) {return}

    $pester.results = Get-GlobalTestResults
    $pester.margin = " " * $pester.results.TestDepth
    $pester.results.TestDepth += 1
    $pester.results.CurrentDescribe = @{
        name = $name
        Tests = @()
    }

    #$pester.output = $pester.margin + "Describing " + $name
    #Write-Host -ForegroundColor Magenta $($pester.output)
	
	$scenario = @{}
    $scenario.steps = New-Object System.Collections.Queue
	New-TestDrive
	
	& $fixture
	$It = Scenario-To-It $name $scenario
	$fixture = [scriptblock]::Create($It)
	& $fixture
	
	Remove-TestDrive

    $pester.Scope = "Describe" #may have been switched to context
		
    $pester.results.Describes += $pester.results.CurrentDescribe
    $pester.results.TestDepth -= 1
}

function Scenario-To-It {
param(
	$name,
    $scenario
)
    $scenario_text = "It '$name' {"
    foreach($step in $scenario.steps) {
        $step.Keys | % {
            $scenario_text += $step[$_].ToString()
        }
    }
    
    return $scenario_text + "}"
}

function Step {
param(
    $name, 
    [ScriptBlock] $test = $(Throw "No test script block is provided. (Have you put the open curly brace on the next line?)")
)
    $scenario.steps.Enqueue(@{$name=$test})
}

function Given {
param(
    $name, 
    [ScriptBlock] $test
)
    Step $name $test
}

function And {
param(
    $name, 
    [ScriptBlock] $test
)
    Step $name $test
}

function When {
param(
    $name, 
    [ScriptBlock] $test
)
    Step $name $test
}

function Then {
param(
    $name, 
    [ScriptBlock] $test
)
    Step $name $test
}