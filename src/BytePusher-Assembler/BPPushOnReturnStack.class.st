Class {
	#name : #BPPushOnReturnStack,
	#superclass : #BPPushOnStack,
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPPushOnReturnStack >> stackName [
	^ #RETURN_STACK
]

{ #category : #accessing }
BPPushOnReturnStack >> stackPointerRegisterName [
	^ #RETURN_SP
]
