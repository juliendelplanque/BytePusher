Class {
	#name : #BPCmpPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPCmpPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #CMP_PAGE;
		yourself
]

{ #category : #generating }
BPCmpPageBuilder >> byteForAddress: anInteger [
	| x y |
	x := (anInteger & 16rFF00) >> 8.
	y := anInteger & 16rFF.
	^ x = y
		ifTrue: [ TRUE_VALUE ]
		ifFalse: [ FALSE_VALUE ]
]
