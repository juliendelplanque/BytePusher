Class {
	#name : #BPOpcodeBankBuilder,
	#superclass : #Object,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPOpcodeBankBuilder class >> bankSize [
	^ 16rFFFF
]

{ #category : #'instance creation' }
BPOpcodeBankBuilder class >> reservedMemoryZone [
	^ BPOpcodeBankReservedMemoryZone new
		opcodeBank: self new;
		yourself
]

{ #category : #'instance creation' }
BPOpcodeBankBuilder class >> reservedMemoryZoneStartingAt: anAddress [
	^ self reservedMemoryZone
		startAddress: anAddress asBPAddress;
		yourself
]

{ #category : #accessing }
BPOpcodeBankBuilder >> bankSize [
	^ self class bankSize
]

{ #category : #generating }
BPOpcodeBankBuilder >> byteForAddress: anInteger [
	"Generates the byte for the address of the bank provided."
	^ self subclassResponsibility
]
