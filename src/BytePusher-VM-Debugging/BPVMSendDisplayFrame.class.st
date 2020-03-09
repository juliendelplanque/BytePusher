Class {
	#name : #BPVMSendDisplayFrame,
	#superclass : #BPVMStepperState,
	#category : #'BytePusher-VM-Debugging-Stepper'
}

{ #category : #executing }
BPVMSendDisplayFrame >> executeFor: stepper [
	stepper beInSendAudioState
]
