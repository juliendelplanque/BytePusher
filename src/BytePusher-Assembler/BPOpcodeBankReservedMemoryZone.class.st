Class {
	#name : #BPOpcodeBankReservedMemoryZone,
	#superclass : #BPReservedMemoryZone,
	#instVars : [
		'opcodeBank'
	],
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #testing }
BPOpcodeBankReservedMemoryZone >> isForOpcodeBank [
	^ true
]

{ #category : #accessing }
BPOpcodeBankReservedMemoryZone >> opcodeBank [
	^ opcodeBank
]

{ #category : #accessing }
BPOpcodeBankReservedMemoryZone >> opcodeBank: anObject [
	opcodeBank := anObject
]

{ #category : #serialization }
BPOpcodeBankReservedMemoryZone >> writeBankOn: aByteArray [ 
	self startAddress memoryAddress to: self endAddress memoryAddress do: [ :address | 
		aByteArray
			at: address + 1 "In byte pusher, addressing starts at 0, in Pharo it starts at 1."
			put: (self opcodeBank byteForAddress: address)	 ]
]
