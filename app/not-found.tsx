import Link from 'next/link'

export default function NotFound() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="text-center px-4">
        <h1 className="text-6xl font-bold text-gray-300 mb-4">404</h1>
        <h2 className="text-xl font-semibold text-gray-700 mb-2">
          サービスが見つかりません
        </h2>
        <p className="text-gray-500 mb-6">
          指定されたサービスは存在しないか、現在利用できません。
        </p>
        <Link
          href="/"
          className="inline-block px-6 py-3 bg-gray-700 text-white rounded-lg hover:bg-gray-800 transition-colors"
        >
          トップページへ戻る
        </Link>
      </div>
    </div>
  )
}
