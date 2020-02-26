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
	self opcodeBank writeBankOn: aByteArray
]
