Class {
	#name : #BPOpcodeBankBuilder,
	#superclass : #Object,
	#category : #BytePusher
}

{ #category : #'as yet unclassified' }
BPOpcodeBankBuilder >> endAddress [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
BPOpcodeBankBuilder >> startAddress [
	^ self subclassResponsibility
]

{ #category : #writing }
BPOpcodeBankBuilder >> writeBankOn: aByteArray [
	^ self subclassResponsibility
]
