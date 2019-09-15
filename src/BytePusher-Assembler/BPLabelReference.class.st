Class {
	#name : #BPLabelReference,
	#superclass : #Object,
	#instVars : [
		'label'
	],
	#category : #'BytePusher-Assembler'
}

{ #category : #'instance creation' }
BPLabelReference class >> label: label [
	^ self new
		label: label;
		yourself
]

{ #category : #visiting }
BPLabelReference >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPLabelReference: self
]

{ #category : #converting }
BPLabelReference >> asDataReference [
	^ BPAddressDataReference new
		address: self;
		yourself
]

{ #category : #accessing }
BPLabelReference >> label [
	^ label
]

{ #category : #accessing }
BPLabelReference >> label: anObject [
	label := anObject
]
