"
I push some data on the data stack and update stack pointer (SP) accordingly.
"
Class {
	#name : #BPPushOnDataStack,
	#superclass : #BPPushOnStack,
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPPushOnDataStack >> stackName [
	^ #DATA_STACK
]

{ #category : #accessing }
BPPushOnDataStack >> stackPointerRegisterName [
	^ #SP
]
