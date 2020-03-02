"
I pop data at top of the the data stack, move it to destionation and update stack pointer (SP) accordingly.
"
Class {
	#name : #BPPopFromDataStack,
	#superclass : #BPPopFromStack,
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPPopFromDataStack >> stackName [
	^ #DATA_STACK
]

{ #category : #accessing }
BPPopFromDataStack >> stackPointerRegisterName [
	^ #SP
]
