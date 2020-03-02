Class {
	#name : #BPPopFromReturnStack,
	#superclass : #BPPopFromStack,
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPPopFromReturnStack >> stackName [
	^ #RETURN_STACK
]

{ #category : #accessing }
BPPopFromReturnStack >> stackPointerRegisterName [
	^ #RETURN_SP
]
