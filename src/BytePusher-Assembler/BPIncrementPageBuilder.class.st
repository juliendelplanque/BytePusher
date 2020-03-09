Class {
	#name : #BPIncrementPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPIncrementPageBuilder class >> bankSize [
	^ 16rFF
]

{ #category : #accessing }
BPIncrementPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #INCREMENT_PAGE;
		yourself
]

{ #category : #accessing }
BPIncrementPageBuilder class >> startAddress [
	^ 16r40100 asBPAddress
]

{ #category : #generating }
BPIncrementPageBuilder >> byteForAddress: anInteger [
	^ (anInteger & 16rFF) + 1 % 16r100
]
