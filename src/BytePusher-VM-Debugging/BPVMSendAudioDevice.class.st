Class {
	#name : #BPVMSendAudioDevice,
	#superclass : #BPVMStepperState,
	#category : #'BytePusher-VM-Debugging-Stepper'
}

{ #category : #executing }
BPVMSendAudioDevice >> executeFor: stepper [
	stepper beInReadKeyboardState
]
