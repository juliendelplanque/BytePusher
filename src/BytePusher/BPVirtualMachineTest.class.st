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

{ #category : #test }
BPVirtualMachineTest >> testInnerStep [
	"Write 42 data at address 50."
	vm memoryAt: 50 put: 42.
	"Write 43 data at address 10."
	vm memoryAt: 51 put: 43.
	"Let's write a simple instruction that copy data at address 50 to address 51 and then jump to address 50."
	vm memoryAt: vm userMemoryAddress putInteger: 50.
	vm memoryAt: vm userMemoryAddress + 3 putInteger: 51.
	vm memoryAt: vm userMemoryAddress + 6 putInteger: 50.
	"Set the program counter."
	vm programCounter: vm userMemoryAddress.
	
	vm innerStep.
	
	self assert: vm programCounter equals: 50.
	self assert: (vm memoryAt: 50) equals: 42.
	self assert: (vm memoryAt: 51) equals: 42
]

{ #category : #test }
BPVirtualMachineTest >> testMemoryAtPutInteger [
	vm memoryAt: 10 putInteger: 16r123456.
	
	self assert: (vm memoryAt: 10) equals: 16r12.
	self assert: (vm memoryAt: 11) equals: 16r34.
	self assert: (vm memoryAt: 12) equals: 16r56.
]

{ #category : #'tests-memory manipulation' }
BPVirtualMachineTest >> testMemoryCopyBytesFrom [
	vm memory: #[16rFF 16r0F 16r42 16r22].
	
	self assert: (vm memoryCopy: 2 bytesFrom: 2) equals: #[16r42 16r22]
]
