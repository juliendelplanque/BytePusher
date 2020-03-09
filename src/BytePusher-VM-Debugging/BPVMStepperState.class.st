Class {
	#name : #BPVMStepperState,
	#superclass : #Object,
	#category : #'BytePusher-VM-Debugging-Stepper'
}

{ #category : #executing }
BPVMStepperState >> executeFor: stepper [
	self subclassResponsibility
]
