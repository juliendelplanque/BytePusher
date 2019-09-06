"
A BPVirtualMachineTest is a test class for testing the behavior of BPVirtualMachine
"
Class {
	#name : #BPVirtualMachineTest,
	#superclass : #TestCase,
	#instVars : [
		'vm'
	],
	#category : #'BytePusher-Tests'
}

{ #category : #initialization }
BPVirtualMachineTest >> setUp [
	vm := BPVirtualMachine new
]

{ #category : #'tests-memory manipulation' }
BPVirtualMachineTest >> testExtractBytesStartingAt [
	vm memory: #[16rFF 16r0F 16r42 16r22].
	
	self assert: (vm extract: 2 bytesStartingAt: 0) equals: 16rFF0F.
	self assert: (vm extract: 2 bytesStartingAt: 2) equals: 16r4222.
]

{ #category : #'tests-memory manipulation' }
BPVirtualMachineTest >> testMemoryCopyBytesFrom [
	vm memory: #[16rFF 16r0F 16r42 16r22].
	
	self assert: (vm memoryCopy: 2 bytesFrom: 2) equals: #[16r42 16r22]
]
