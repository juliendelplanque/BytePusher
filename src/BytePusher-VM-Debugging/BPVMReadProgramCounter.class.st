Class {
	#name : #BPVMReadProgramCounter,
	#superclass : #BPVMStepperState,
	#category : #'BytePusher-VM-Debugging-Stepper'
}

{ #category : #executing }
BPVMReadProgramCounter >> executeFor: stepper [
	stepper beInInnerLoopState
]
