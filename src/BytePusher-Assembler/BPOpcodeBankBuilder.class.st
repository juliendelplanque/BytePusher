Class {
	#name : #BPOpcodeBankBuilder,
	#superclass : #Object,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPOpcodeBankBuilder class >> bankSize [
	^ 16rFFFF
]

{ #category : #accessing }
BPOpcodeBankBuilder class >> endAddress [
	^ self startAddress + self bankSize
]

{ #category : #accessing }
BPOpcodeBankBuilder class >> reservedMemoryZone [
	^ BPOpcodeBankReservedMemoryZone new
		startAddress: self startAddress;
		endAddress: self endAddress;
		opcodeBank: self new;
		yourself
]

{ #category : #accessing }
BPOpcodeBankBuilder class >> startAddress [
	^ self subclassResponsibility
]

{ #category : #writing }
BPOpcodeBankBuilder class >> writeBankOn: aByteArray [
	^ self new writeBankOn: aByteArray
]

{ #category : #generating }
BPOpcodeBankBuilder >> byteForAddress: anInteger [
	"Generates the byte for the address of the bank provided."
	^ self subclassResponsibility
]

{ #category : #accessing }
BPOpcodeBankBuilder >> endAddress [
	^ self class endAddress
]

{ #category : #accessing }
BPOpcodeBankBuilder >> reservedMemoryZone [
	^ self class reservedMemoryZone
]

{ #category : #accessing }
BPOpcodeBankBuilder >> startAddress [
	^ self class startAddress
]
