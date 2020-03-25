Class {
	#name : #BPDecrementPageBuilder,
	#superclass : #BPPageInitializer,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPDecrementPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #DECREMENT_PAGE;
		yourself
]

{ #category : #generating }
BPDecrementPageBuilder >> byteForAddress: anInteger [
	^ (anInteger & 16rFF) - 1 % 16r100
]
