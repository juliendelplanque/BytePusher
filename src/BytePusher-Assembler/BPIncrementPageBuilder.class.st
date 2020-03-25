Class {
	#name : #BPIncrementPageBuilder,
	#superclass : #BPPageInitializer,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPIncrementPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #INCREMENT_PAGE;
		yourself
]

{ #category : #generating }
BPIncrementPageBuilder >> byteForAddress: anInteger [
	^ (anInteger & 16rFF) + 1 % 16r100
]
