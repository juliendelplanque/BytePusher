Class {
	#name : #BPDecrementPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPDecrementPageBuilder class >> bankSize [
	^ 16rFF
]

{ #category : #accessing }
BPDecrementPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #DECREMENT_PAGE;
		yourself
]

{ #category : #accessing }
BPDecrementPageBuilder class >> startAddress [
	^ 16r40200 asBPAddress
]

{ #category : #generating }
BPDecrementPageBuilder >> byteForAddress: anInteger [
	^ (anInteger & 16rFF) - 1 % 16r100
]
