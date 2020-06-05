Class {
	#name : #BPLabelReference,
	#superclass : #BPEntityToResolve,
	#instVars : [
		'label'
	],
	#category : #'BytePusher-Assembler-Model'
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

{ #category : #accessing }
BPLabelReference >> address [
	^ self label address
]

{ #category : #converting }
BPLabelReference >> asAddressReference [
	^ BPAddressReference new
		objectWithAddress: self;
		yourself
]

{ #category : #converting }
BPLabelReference >> asDataReference [
	^ BPAddressDataReference new
		objectWithAddress: self;
		yourself
]

{ #category : #'assembler-dispatch' }
BPLabelReference >> forAssembler: aJollyAssembler [ 
	^ self
]

{ #category : #accessing }
BPLabelReference >> label [
	^ label
]

{ #category : #accessing }
BPLabelReference >> label: anObject [
	label := anObject
]
