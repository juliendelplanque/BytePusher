"
A BPVMStepperTest is a test class for testing the behavior of BPVMStepper
"
Class {
	#name : #BPVMStepperTest,
	#superclass : #TestCase,
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-VM-Debugging-Tests-Stepper'
}

{ #category : #tests }
BPVMStepperTest >> testStateMachine [
	| vm stepper |
	vm := BPVirtualMachine new.
	stepper := vm stepper.
	
	self assert: stepper state class equals: BPVMReadKeyboard.
	stepper step.
	self assert: stepper state class equals: BPVMReadProgramCounter.
	stepper step.
	self assert: stepper state class equals: BPVMInnerLoop.
	INSTRUCTIONS_PER_STEP - 1 timesRepeat: [ 
		stepper step.
		self assert: stepper state class equals: BPVMInnerLoop ].
	
	stepper step.
	self assert: stepper state class equals: BPVMSendDisplayFrame.
	stepper step.
	self assert: stepper state class equals: BPVMSendAudioDevice.
	stepper step.
	self assert: stepper state class equals: BPVMReadKeyboard.
]
