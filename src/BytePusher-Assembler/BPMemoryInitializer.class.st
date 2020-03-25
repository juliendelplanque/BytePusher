Class {
	#name : #BPMemoryInitializer,
	#superclass : #Object,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPMemoryInitializer class >> bankSize [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
BPMemoryInitializer class >> reservedMemoryZone [
	^ BPOpcodeBankReservedMemoryZone new
		opcodeBank: self new;
		yourself
]

{ #category : #'instance creation' }
BPMemoryInitializer class >> reservedMemoryZoneStartingAt: anAddress [
	^ self reservedMemoryZone
		startAddress: anAddress asBPAddress;
		yourself
]

{ #category : #accessing }
BPMemoryInitializer >> bankSize [
	^ self class bankSize
]

{ #category : #generating }
BPMemoryInitializer >> byteForAddress: anInteger [
	"Generates the byte for the address of the bank provided."
	^ self subclassResponsibility
]
