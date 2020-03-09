Class {
	#name : #BPVMInnerLoop,
	#superclass : #BPVMStepperState,
	#instVars : [
		'counter'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-VM-Debugging-Stepper'
}

{ #category : #executing }
BPVMInnerLoop >> executeFor: stepper [
	stepper executeInnerLoop.
	counter := counter + 1.
	counter = INSTRUCTIONS_PER_STEP
		ifTrue: [ 
			counter :=0.
			stepper beInSendDisplayState ]
]

{ #category : #initialization }
BPVMInnerLoop >> initialize [
	super initialize.
	counter := 0
]
