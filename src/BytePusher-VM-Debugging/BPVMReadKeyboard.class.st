Class {
	#name : #BPVMReadKeyboard,
	#superclass : #BPVMStepperState,
	#category : #'BytePusher-VM-Debugging-Stepper'
}

{ #category : #executing }
BPVMReadKeyboard >> executeFor: stepper [
	stepper beInReadProgramCounterState
]
