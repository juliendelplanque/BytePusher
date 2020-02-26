Class {
	#name : #BPOpcodeBankBuilder,
	#superclass : #Object,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #writing }
BPOpcodeBankBuilder class >> endAddress [
	^ self startAddress + 16rFFFF
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

{ #category : #private }
BPOpcodeBankBuilder >> addressesRange [
	^ self startAddress memoryAddress to: self endAddress memoryAddress
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

{ #category : #writing }
BPOpcodeBankBuilder >> writeBankOn: aByteArray [
	^ self subclassResponsibility
]
