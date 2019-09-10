Class {
	#name : #BPOpcodeBankBuilder,
	#superclass : #Object,
	#category : #'BytePusher-Assembly'
}

{ #category : #accessing }
BPOpcodeBankBuilder class >> endAddress [
	^ self subclassResponsibility
]

{ #category : #accessing }
BPOpcodeBankBuilder class >> reservedMemoryZone [
	^ BPReservedMemoryZone new
		startAddress: self startAddress;
		endAddress: self endAddress;
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
