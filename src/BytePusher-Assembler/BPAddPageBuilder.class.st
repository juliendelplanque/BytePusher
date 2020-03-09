Class {
	#name : #BPAddPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPAddPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #ADD_PAGE;
		yourself
]

{ #category : #generating }
BPAddPageBuilder >> byteForAddress: anInteger [
	| x y |
	x := (anInteger & 16rFF00) >> 8.
	y := anInteger & 16rFF.
	^ (x + y) % 16rFF
]
